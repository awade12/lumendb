"""
LumenDB - A modern database solution
"""

import click
from rich.console import Console
from . import cmds
import os

# Read version from version.txt
with open(os.path.join(os.path.dirname(os.path.dirname(__file__)), 'version.txt')) as f:
    __version__ = f.read().strip()

console = Console()

class Database:
    def __init__(self, path: str = None):
        """Initialize the database.
        
        Args:
            path: Optional path to the database file
        """
        self.path = path
        
    def connect(self):
        """Connect to the database."""
        pass
        
    def disconnect(self):
        """Disconnect from the database."""
        pass
        
    def query(self, query: str):
        """Execute a query.
        
        Args:
            query: The query to execute
        """
        pass

@click.group()
@click.version_option(version=__version__)
def main():
    """lumendb -- a ez/setup db"""
    pass



main.add_command(cmds.help)

if __name__ == '__main__':
    main()
