from unittest import TestCase
from unittest.mock import patch, Mock
from py.functions.transcribe_video_audio import TextTranscriber


class TestTranscribeVideoAudio(TestCase):
    def setUp(self):
        with open("tests/testaudio.mp4", "rb") as f:
            self.bytes_data_mp4 = f.read()
            self.bytes_list_mp4 = list(self.bytes_data_mp4)

    def test_extract_audio(self):
        transcriber = TextTranscriber(self.bytes_list_mp4, "mp4")
        result = transcriber._extract_audio()
        with open("tests/testaudio.mp3", "wb") as f:
            f.write(result)
