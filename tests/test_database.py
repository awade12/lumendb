"""
Tests for the Database class
"""

import pytest
from lumendb import Database

def test_database_init():
    """Test database initialization."""
    db = Database("test.db")
    assert db.path == "test.db"

def test_database_connect():
    """Test database connection."""
    db = Database("test.db")
    db.connect()  # Should not raise an exception

def test_database_query():
    """Test database query."""
    db = Database("test.db")
    db.connect()
    result = db.query("SELECT 1")
    assert result is None  # Currently the query method returns None 