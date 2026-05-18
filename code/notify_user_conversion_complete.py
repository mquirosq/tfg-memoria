def notify_user_conversion_complete(user, task):
    task_ref = getattr(task, 'process_name')
    message = f"The {task.task_type} for the process {task_ref} is complete. You can now access your results."
    return _create_notification(
        user=user,
        event_type=TaskNotification.EVENT_COMPLETED,
        message=message,
        task=task,
    )