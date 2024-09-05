from unittest import TestCase
from mock import patch, Mock
from py.functions.transcribe_video_audio import TextTranscriber


class TestTranscribeVideoAudio(TestCase):
    def setUp(self):
        with open("tests/testaudio.mp4", "rb") as f:
            self.bytes_data_mp4 = f.read()
            self.bytes_list_mp4 = list(self.bytes_data_mp4)

        with open("tests/testaudio.mkv", "rb") as f:
            self.bytes_data_mk = f.read()
            self.bytes_list_mk = list(self.bytes_data_mk)

    def test_extract_audio(self):
        transcriber_mp4 = TextTranscriber(self.bytes_list_mp4, "mp4")
        result = transcriber_mp4._extract_audio()
        assert isinstance(result, bytes)

        transcriber_mkv = TextTranscriber(self.bytes_list_mk, "mkv")
        result = transcriber_mkv._extract_audio()
        assert isinstance(result, bytes)
