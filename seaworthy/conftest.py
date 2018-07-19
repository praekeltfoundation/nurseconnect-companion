import os


def pytest_addoption(parser):
    parser.addoption(
        "--phoenix-image", action="store", default=os.environ.get(
            "PHOENIX_IMAGE", "praekeltfoundation/nurseconnect-companion:develop"),
        help="Phoenix Docker image to test")


def pytest_report_header(config):
    return "\n".join((
        "Phoenix Docker image: {}".format(config.getoption("--phoenix-image")),
    ))
