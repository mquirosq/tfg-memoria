def get_job_status(job_id):
    response = requests.get(f"{BASE}/jobs/{job_id}")
    response.raise_for_status()
    status = response.json()["status"]
    return status, response.status_code
