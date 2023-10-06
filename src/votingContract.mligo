// VOTE CONTRACT
// POSSIBLE ACTIONS ON CONTRACT

type action =
| SetAdmin of address
| SetPaused of unit
| Vote of bool
| Reset of unit

// STORAGE OF CONTRACT

type storage =
  {
   admin : address;
   paused : bool;
   votes : (address, bool) map;
   number_of_votes : nat
  }

// RETURN TYPE OF FUNCTIONS

type return = operation list * storage

// ADMIN FUNCTIONS

let isAdmin (storage : storage) : bool =
  if (storage.admin = (Tezos.get_sender ()))
  then True
  else False

// CHANGE ADMIN ADDRESS

let setAdmin (new_admin : address) (storage : storage) : return =
  if isAdmin (storage)
  then (failwith "[ADMIN] You are the admin, you cannot change the admin.")
  else ([], {storage with admin = new_admin})

// PAUSE CONTRACT OR UNPAUSE CONTRACT

let setPaused (storage : storage) : return =
  if isAdmin (storage)
  then (failwith "[ADMIN] Only the admin can pause the contract.")
  else
    (match storage.paused with
       True -> ([], {storage with paused = False})
     | False -> ([], {storage with paused = True}))

// SUBMIT VOTE AS A VOTER (NOT ADMIN) - ONLY IF CONTRACT IS NOT PAUSED

let submitVote (vote : bool) (storage : storage) : return =
  if storage.paused
  then (failwith "[PAUSED] Vote contract is in its paused state.")
  else
    (if isAdmin (storage)
     then (failwith "[ADMIN] You are the admin, you cannot vote.")
     else
       (if (storage.number_of_votes >= 10n)
        then
          (failwith
             "[VOTER] The vote has already been completed (10 votes max).")
        else
          (let vote_opt : bool option =
             Map.find_opt (Tezos.get_sender ()) storage.votes in
           match vote_opt with
             Some (_) -> failwith ("[VOTER] Your address has already voted.")
           | None ->
               (let new_votes_map : (address, bool) map = storage.votes in
                let _ = Map.add (Tezos.get_sender ()) vote new_votes_map in
                ([], {storage with votes = new_votes_map})))))

// RESET VOTES - ONLY BY ADMIN - ONLY IF CONTRACT IS PAUSED

let submitReset (storage : storage) : return =
  if isAdmin (storage)
  then
    (if storage.paused
     then
       ([],
        {storage with paused = False; votes = Map.empty; number_of_votes = 0n})
     else (failwith "[PAUSED] Vote contract is not paused."))
  else (failwith "[ADMIN] You need admin privileges to run this function.")

// ENTRY POINTS

[@entry]
let main (p : action) (s : storage) : return =
  match p with
    SetAdmin (n) -> setAdmin n s
  | SetPaused () -> setPaused s
  | Vote (n) -> submitVote n s
  | Reset () -> submitReset s
