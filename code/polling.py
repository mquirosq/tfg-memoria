@shared_task(bind=True, autoretry_for=(Exception,), retry_backoff=10, max_retries=1000)
def poll_conversion_status(self, task_id):
    task = Task.objects.get(id=task_id)
    status, code = get_job_status(task.external_job_id)

    if code == 404:
        task.status = "failed"
        task.save()
        notify_user_conversion_failed(task.user, task)
        return
    
    if status != task.status:
        if status == "annotated" or status == "assembled":
            status = "completed"
        task.status = status
        task.save()

    if status == "completed":
        _persist_output(task)
        _cleanup_temp_fastq_inputs(task)
        notify_user_conversion_complete(task.user, task)
        return

    if status == "failed":
        notify_user_conversion_failed(task.user, task)
        return

    try:
        self.retry(countdown=60)  # Retry after 60 seconds
    
    except MaxRetriesExceededError: # When retries are exhausted
        task.status = "failed"
        task.save()
        notify_user_conversion_failed(task.user, task)
        return