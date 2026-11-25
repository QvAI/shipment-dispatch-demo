import unittest

from tools.probe import repository


class ShipmentSmokeTest(unittest.TestCase):
    def test_first_submission_creates_one_shipment(self):
        with repository() as (submit, rows):
            self.assertGreater(submit("REQ-101", "DEB"), 0)
            self.assertEqual(rows(), 1)
