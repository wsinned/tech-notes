from datetime import date, timedelta
from pathlib import Path
from subprocess import call
import argparse
import os

class TargetDate:

    def __init__(self, theDate: date) -> None:
        self.weekStarting = theDate

    def toFileDate(self):
        return self.weekStarting.isoformat()
    
    def toHeaderDate(self):
        return self.weekStarting.strftime("%A %d %B %Y")
    
    def toPathYear(self):
        return self.weekStarting.strftime("%Y")
    
    def toPathMonth(self):
        return self.weekStarting.strftime("%m")
    
class Notes:
    rootpath = Path.home().joinpath(os.getenv('NOTES_ROOT'))
    workspace = rootpath.joinpath("notes.code-workspace")

    def createFile(self, week: TargetDate):
        path = Path.joinpath(Notes.rootpath, week.toPathYear(), week.toPathMonth())
        
        if not path.exists():
            Path.mkdir(path)

        Notes.note = Path.joinpath(path, f"{week.toFileDate()}-Weekly-log.md")
        if not Notes.note.exists():
            Notes.note.write_text(self.getBoilerplate(week))

        return self

    def getBoilerplate(self, week: TargetDate):
        text = f"# Weekly Plan - W/C {week.toHeaderDate()}"
        text += "\n\n# 1:1 Notes This Week\n\n\n"
        text += "# Monday\n\n\n# Tuesday\n\n\n# Wednesday\n\n\n# Thursday\n\n\n# Friday\n"
        return text

    def openFile(self, ):
        print(f"Opening {Notes.note.absolute()}")
        call(["code", Notes.workspace, Notes.note])
        
def getMonday(theDate: date):
    return theDate.replace(day=theDate.day - (theDate.isoweekday()-1))

def init_argparse() -> argparse.ArgumentParser:
    help="Open a markdown notes file for the requested week in a VS Code workspace."
    help+=" Requires the NOTES_ROOT environment variable to be set."

    parser = argparse.ArgumentParser(
        usage="%(prog)s [OPTION]",
        description=help
    )
    parser.add_argument(
        "-v", "--version", action="version",
        version = f"{parser.prog} version 1.0.0"
    )
    parser.add_argument('--thisWeek', action="store_true", help="Open this week's notes")
    parser.add_argument('--nextWeek', action="store_true", help="Open next week's notes")
    parser.add_argument('--lastWeek', action="store_true", help="Open last week's notes")
    return parser

def main() -> None:
    parser = init_argparse()
    args = parser.parse_args()
   
    if args.thisWeek:
        delta = timedelta(0)
    elif args.nextWeek:
        delta = timedelta(7)
    elif args.lastWeek:
        delta = timedelta(-7)
    else:
        parser.print_help()
        exit()

    monday = getMonday(date.today()) + delta
    thisWeek = TargetDate(monday)
    Notes().createFile(thisWeek).openFile()

if __name__ == "__main__":
    main()
