from unittest import TestCase
from os.path import dirname, join
from pytezos import ContractInterface, MichelsonRuntimeError

admin       = "tz1LKe9GQfF4wfob11YjH9grP1YdEWZtPe9W"
non_admin   = "tz1PJSVnbr8ztVSrT2NuBEmGubnYKcxk3zie"

wallet1 = "tz1dFibFVfuWLBVJHSGrneVFKimuJauc5rEV"
wallet2 = "tz1ajkFrcXfHAXJm8yK8s7mamwth9u4ajzjw"
wallet3 = "tz1VtUMXUwuAfN4euuGg6YC23QT5WDk94M74"
wallet4 = "tz1fPexY96eBrdzXySYzyqq6vM2ZpN5e4q2g"
wallet5 = "tz1LuiwRnA63anqr6ot86xJR3VK86qJxURDj"
wallet6 = "tz1gzyiEoqCCoNjUpmJA1Z21cSf1VzS61E89"
wallet7 = "tz1fssLLW3K822LGaH219oF9ZF8FW8izZXRH"
wallet8 = "tz1fDYG7TcBXBMRfoB5QEtXqF1YunSo17aeo"
wallet9 = "tz1iWiN1hqFHEJEGW4gunUW6o2t1SC8sJoKT"

class pyTestContract(TestCase):

    @classmethod
    def setUpClass(cls):
        project_dir = dirname(dirname(__file__))
        cls.votingContract = ContractInterface.create_from(join(project_dir, 'votingContract.tz'))

    def test_vote(self):
        result = self.votingContract.vote(True).result(
            storage = {
            "votes": { },
            "paused": False,
            "admin": admin
            },
            source = non_admin
        )
        self.assertEqual(True, result.storage['votes'][non_admin])
    
    def test_admin_vote(self):
        with self.assertRaises(MichelsonRuntimeError):
            self.votingContract.vote(False).result(
                storage = {
                "votes": { non_admin: True },
                "paused": False,
                "admin": admin
                },
                source = admin
            )
    
    def test_vote_twice(self):
        with self.assertRaises(MichelsonRuntimeError):
            self.votingContract.vote(True).result(
                storage = {
                "votes": { non_admin: True },
                "paused": False,
                "admin": admin
                },
                source = non_admin
            )
        
    def test_vote_paused(self):
        with self.assertRaises(MichelsonRuntimeError):
            self.votingContract.vote(True).result(
                storage = {
                "votes": { wallet1: True },
                "paused": True,
                "admin": admin
                },
                source = non_admin
            )
    
    def test_vote_pausing(self):
        result = self.votingContract.vote(True).result(
            storage = {
            "votes": { wallet1: True, wallet2: False, wallet3: False, wallet4: False, wallet5: False, wallet6: False, wallet7: False, wallet8: False , wallet9: False },
            "paused": False,
            "admin": admin
            },
            source = non_admin
        )
        self.assertEqual(10, result.storage["voteCount"])
        self.assertEqual(True, result.storage['paused'])
    
    def test_reset(self):
        result = self.votingContract.reset(
            0
        ).result(
            storage = {
            "votes": { wallet1 : True },
            "paused": True,
            "admin": admin
            },
            source = non_admin
        )
        self.assertEqual({}, result.storage["votes"])
        self.assertEqual(False, result.storage["paused"])

    def test_reset_not_admin(self):
        with self.assertRaises(MichelsonRuntimeError):
            self.votingContract.reset(
                0
            ).result(
                storage = {
                "votes": { wallet1: True },
                "paused": True,
                "admin": admin
                },
                source = non_admin
            )