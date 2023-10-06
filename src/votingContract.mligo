type action =
| Vote of bool
| Reset of int

type storage =
  {
   admin : address;
   paused : bool;
   votes : (address, bool) map
  }

type return = operation list * storage

let isAdmin (storage : storage) : bool =
  if (storage.admin = (Tezos.get_sender ()))
  then True
  else False

let setAdmin (newAdmin : address) (storage : storage) : return =
  ([], {storage with admin = newAdmin})

let isPaused (storage : storage) : bool =
  if (storage.paused)
  then True
  else False

let setPaused (storage : storage) : return =
  match storage.paused with
    True -> ([], {storage with paused = False})
  | False -> ([], {storage with paused = True})

let submitVote (vote : bool) (storage : storage) : return =
  if storage.paused
  then (failwith "[PAUSED] Vote contract is in its paused state.")
  else
    (if isAdmin (storage)
     then (failwith "[ADMIN] You are the admin, you cannot vote.")
     else
       (let vote_opt : bool option =
          Map.find_opt (Tezos.get_sender ()) storage.votes in
        match vote_opt with
          Some (_) -> failwith ("[VOTER] Your address has already voted.")
        | None ->
            (let new_votes_map : (address, bool) map = storage.votes in
             let _ = Map.add (Tezos.get_sender ()) vote new_votes_map in
             ([], {storage with votes = new_votes_map}))))

let submitReset (storage : storage) : return =
  if isAdmin (storage)
  then
    (let new_votes_map : (address, bool) map = Map.empty in
     ([], {storage with paused = False; votes = new_votes_map}))
  else (failwith "[ADMIN] You need admin privileges to run this function.")

[@entry]
let main (p : action) (s : storage) : return =
  match p with
    Vote (n) -> submitVote n s
  | Reset (_) -> submitReset s
