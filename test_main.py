# test_main.py

# main.py dosyasından 'app' objesini import etmeyi dene
try:
    from main import app
except ImportError:
    app = None

def test_app_exists():
    """
    Test if the FastAPI 'app' object can be imported and is not None.
    """
    assert app is not None, "FastAPI 'app' object could not be imported from main.py"

def test_smoke_test():
    """
    A basic 'smoke test' to ensure pytest is running.
    """
    assert True