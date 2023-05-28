#! /usr/bin/env python

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

    def __init__(self, rootenv: str, workspace=None) -> None:
        self.rootenv = rootenv
        self.rootpath = Path.home().joinpath(rootenv)
        self.workspace = workspace
        self.note = Path("")

    def create_file(self, week: TargetDate, templateFile=None):
        path = self._note_folder_path(week)
        self.note = self._note_path(week, path)

        if not self.note.exists():
            if templateFile:
                template_path = Path(templateFile)
                try:
                    template_text = Path.read_text(template_path)
                    final_text = template_text.replace(
                        "HEADER_DATE", week.to_header_date())
                except:
                    print("Error reading template.")
                    sys.exit()
            else:
                final_text = self._get_boilerplate(week)

            try:
                self.note.write_text(final_text)
            except:
                print("Error writing file.")

        return self

    def _note_path(self, week, path):
        return Path.joinpath(
            path, f"{week.to_file_date()}-Weekly-log.md")

    def _note_folder_path(self, week):
        path = Path.joinpath(
            self.rootpath, week.to_path_year(), week.to_path_month())
        
        if not path.exists():
            path.mkdir(parents=True)

        return path

    def _get_boilerplate(self, week: TargetDate):
        text = f"# Weekly Plan - W/C {week.to_header_date()}"
        text += "\n\n# 1:1 Notes This Week\n\n\n"
        text += "# Monday\n\n\n# Tuesday\n\n\n"
        text += "# Wednesday\n\n\n# Thursday\n\n\n# Friday\n"
        return text

    def open_file(self):
        if self.workspace:
            print(f"Opening {self.note.absolute()}, {self.workspace}")
            call(["code", self.rootpath.joinpath(self.workspace), self.note])
        else:
            print(f"Opening {self.note.absolute()}")
            call(["code", self.note])


def get_monday(the_date: date):
    return the_date.replace(day=the_date.day - (the_date.isoweekday()-1))


def init_argparse() -> argparse.ArgumentParser:
    help_text = """Open a markdown notes file for the requested 
        week in a VS Code workspace. 
        Requires the NOTES_ROOT environment variable to be set."""

    parser = argparse.ArgumentParser(
        usage="%(prog)s [OPTIONS]",
        description=help_text
    )
    parser.add_argument(
        "-v", "--version", action="version",
        version=f"{parser.prog} version 1.0.0"
    )
    parser.add_argument("--thisWeek", action="store_true",
                        help="Open this week's notes")
    parser.add_argument("--nextWeek", action="store_true",
                        help="Open next week's notes")
    parser.add_argument("--lastWeek", action="store_true",
                        help="Open last week's notes")
    parser.add_argument("--workspace", action="store",
                        help="The VS Code workspace to use in the NOTES_ROOT folder.")
    parser.add_argument("--useTemplate", action="store",
                        help="The path to the template file to use")
    return parser


def process_args():
    parser = init_argparse()
    args = parser.parse_args()
    workspace = None
    templateFile = None

    if args.thisWeek:
        delta = timedelta(0)
    elif args.nextWeek:
        delta = timedelta(7)
    elif args.lastWeek:
        delta = timedelta(-7)
    else:
        parser.print_help()
        sys.exit()

    if args.workspace:
        workspace = args.workspace

    if args.useTemplate:
        templateFile = args.useTemplate

    return (workspace, templateFile, delta)


def main() -> None:
    workspace, templateFile, delta = process_args()

    monday = get_monday(date.today()) + delta
    this_week = TargetDate(monday)

    rootenv = os.getenv('NOTES_ROOT') or "~"
    Notes(rootenv, workspace).create_file(this_week, templateFile).open_file()


if __name__ == "__main__":
    main()
