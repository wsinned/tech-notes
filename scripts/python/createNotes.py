from datetime import date, timedelta
from pathlib import Path
from subprocess import call
import argparse
import os
import sys


class TargetDate:

    def __init__(self, the_date: date) -> None:
        self.week_starting = the_date

    def to_file_date(self):
        return self.week_starting.isoformat()

    def to_header_date(self):
        return self.week_starting.strftime("%A %d %B %Y")

    def to_path_year(self):
        return self.week_starting.strftime("%Y")

    def to_path_month(self):
        return self.week_starting.strftime("%m")


class Notes:
    rootpath = Path.home().joinpath(os.getenv('NOTES_ROOT'))
    workspace = rootpath.joinpath("notes.code-workspace")

    def create_file(self, week: TargetDate):
        path = Path.joinpath(
            Notes.rootpath, week.to_path_year(), week.to_path_month())

        if not path.exists():
            path.mkdir(parents=True)

        Notes.note = Path.joinpath(
            path, f"{week.to_file_date()}-Weekly-log.md")
        if not Notes.note.exists():
            Notes.note.write_text(self.get_boilerplate(week))

        return self

    def get_boilerplate(self, week: TargetDate):
        text = f"# Weekly Plan - W/C {week.to_header_date()}"
        text += "\n\n# 1:1 Notes This Week\n\n\n"
        text += "# Monday\n\n\n# Tuesday\n\n\n"
        text += "# Wednesday\n\n\n# Thursday\n\n\n# Friday\n"
        return text

    def open_file(self, ):
        print(f"Opening {Notes.note.absolute()}")
        call(["code", Notes.workspace, Notes.note])


def get_monday(the_date: date):
    return the_date.replace(day=the_date.day - (the_date.isoweekday()-1))


def init_argparse() -> argparse.ArgumentParser:
    help = "Open a markdown notes file for the requested "
    help += "week in a VS Code workspace."
    help += " Requires the NOTES_ROOT environment variable to be set."

    parser = argparse.ArgumentParser(
        usage="%(prog)s [OPTION]",
        description=help
    )
    parser.add_argument(
        "-v", "--version", action="version",
        version=f"{parser.prog} version 1.0.0"
    )
    parser.add_argument('--thisWeek', action="store_true",
                        help="Open this week's notes")
    parser.add_argument('--nextWeek', action="store_true",
                        help="Open next week's notes")
    parser.add_argument('--lastWeek', action="store_true",
                        help="Open last week's notes")
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
        sys.exit()

    monday = get_monday(date.today()) + delta
    this_week = TargetDate(monday)
    Notes().create_file(this_week).open_file()


if __name__ == "__main__":
    main()
