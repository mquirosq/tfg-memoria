def main():
    """Main setup routine."""
    project_root = Path(__file__).parent
    app_dir = project_root / "app"
    
    print("Cocos Setup")
    print("=" * 50)
    
    # Install Python dependencies
    print("\nInstalling Python dependencies...")
    if run_command([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"], 
                   cwd=project_root):
        print("Failed to install Python dependencies")
        return 1
    
    # Install frontend dependencies
    print("\nInstalling frontend dependencies (Tailwind + daisyUI)...")
    if run_command(["npm", "install"], cwd=app_dir):
        print("Failed to install npm dependencies")
        return 1
    
    # Build CSS
    print("\nBuilding frontend CSS bundle...")
    if run_command(["npm", "run", "build:css"], cwd=app_dir):
        print("Failed to build CSS")
        return 1
    
    print("\n" + "=" * 50)
    print("Setup completed successfully!")
    
    return 0