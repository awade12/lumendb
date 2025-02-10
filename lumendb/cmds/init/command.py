"""
Initialize database command implementation
"""

import click
from rich import print as rprint
from ...main import Database

@click.command()
@click.argument('path', type=click.Path())
def init(path):
    """Initialize a new database at the specified path."""
    try:
        db = Database(path)
        db.connect()
        rprint(f"[green]✓[/green] Database initialized at: {path}")
    except Exception as e:
        rprint(f"[red]✗[/red] Error initializing database: {str(e)}") 