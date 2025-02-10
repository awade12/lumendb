"""
Help command implementation
"""

import click
from rich import print as rprint

@click.command(help="Display helpful information about available commands.")
@click.argument('topic', required=False)
def help_command(topic):
    """Provide help information on a specific topic or general usage."""
    help_texts = {
        "query": "Usage: query <path> [query]\nExecute a query on the database.",
        "connect": "Usage: connect <database>\nConnect to a specified database.",
        "exit": "Usage: exit\nExit the interactive mode.",
    }
    
    if topic:
        rprint(help_texts.get(topic, f"[red]✗[/red] No help available for '{topic}'."))
    else:
        rprint("[cyan]Available topics: query, connect, exit[/cyan]")
        rprint("Use 'help <topic>' for more details.")

if __name__ == "__main__":
    help_command()
