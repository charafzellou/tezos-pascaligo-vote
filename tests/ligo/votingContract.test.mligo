#import "../../src/votingContract.mligo" "Main"

let initial_storage (deploy_admin : address) : Main.storage = {
   admin = deploy_admin;
   paused = false;
   votes = (Map.empty : (address, bool) map);
   number_of_votes = 0n
}

let originate_contract : address * (Main.action, Main.storage) typed_address * Main.action contract =
    let admin = Test.nth_bootstrap_contract 1n in
    let _voter1 = Test.nth_bootstrap_contract 2n in
    let _voter2 = Test.nth_bootstrap_contract 3n in
    let (addr, contr, _) = Test.originate_from_file "../../compiled/main.tz" "main" [] (Test.eval(initial_storage(admin))) 0tez in
    let taddr : (Main.action, Main.storage) typed_address = Test.cast_address addr in
    let contr : Main.action contract = Test.to_contract taddr in
    (addr, taddr, contr)

// let test_initial_storage =
//  let (taddr, _, _) = Test.originate VotingContract.main initial_storage 0tez in
//  assert (Test.get_storage taddr = initial_storage)

// let test_increment =
//  let (taddr, _, _) = Test.originate VotingContract.main initial_storage 0tez in
//  let contr = Test.to_contract taddr in
//  let _ = Test.transfer_to_contract_exn contr (Increment 1) 1mutez in
//  assert (Test.get_storage taddr = initial_storage + 1)