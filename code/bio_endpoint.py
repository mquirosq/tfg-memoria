@app.get("/jobs/{job_id}")
async def get_job_status(job_id: str):
    """Check job status"""
    job = get_job(job_id)
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    return job
