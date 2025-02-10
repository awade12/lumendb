"""
Query database command implementation
"""

import click
from rich import print as rprint
from ...main import Database

@click.command()
@click.argument('path', type=click.Path(exists=True))
@click.argument('query', required=False)
def query(path, query):
    """Execute a query on the database."""
    try:
        db = Database(path)
        db.connect()
        if query:
            result = db.query(query)
            rprint(result)
        else:
            # Start interactive mode
            while True:
                query = click.prompt('query>', type=str)
                if query.lower() in ('exit', 'quit'):
                    break
                result = db.query(query)
                rprint(result)
    except Exception as e:
        rprint(f"[red]✗[/red] Error executing query: {str(e)}")
    finally:
        db.disconnect() 