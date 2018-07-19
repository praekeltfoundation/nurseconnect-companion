import cgi

from fixtures import *  # noqa: F401,F403


def mime_type(content_type):
    return cgi.parse_header(content_type)[0]


class TestPhoenixContainer:
    def test_homepage(self, phoenix_container):
        """
        When the phoenix container starts, it should be able to process web
        requests
        """
        client = phoenix_container.http_client()
        response = client.get("/")

        assert response.status_code == 200
        assert mime_type(response.headers["content-type"]) == "text/html"
        assert "Sign in with Google" in response.text
