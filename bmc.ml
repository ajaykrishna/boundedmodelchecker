open Localizing;;
open Simple_java_syntax;;
module IdMap = Map.Make(struct type t = s_uniqueId let compare x y = x-y end);;
type smt_identifier = string

let get_main_procedure (prog: s_program) =
  let main = ref None in
  try
      List.iter (fun classe ->
        List.iter (fun decl ->
          match decl with
          | Sd_function f when f.s_proc_name = "main" ->
              main := Some f; raise Exit
          | Sd_function _ | Sd_var _ -> ()
        ) classe.s_class_body;
      ) prog;
      None
  with Exit -> !main;;
  
type bmc_state = {
  bmc_channel : out_channel;
  bmc_count : int;
  bmc_error_locations : string list
};;

type bmc_flow = {
(* TODO *)
  bmc_reached : smt_identifier;
};;

let bmc_add_error (state : bmc_state) error = {
  state with bmc_error_locations =
    error :: state.bmc_error_locations
};;

let bmc_merge_flows (in_state : bmc_state)
    (flow1 : bmc_flow) (flow2 : bmc_flow) (extent : extent) =
  failwith "merge flows";;

let rec bmc_block (in_state : bmc_state) (in_flow : bmc_flow)
    (blk : s_block) =
  match blk with
  | [] -> in_state, in_flow
  | head::tail ->
     let out_state1, out_flow1 = bmc_command in_state in_flow head in
     bmc_block out_state1 out_flow1 tail

and bmc_command (in_state : bmc_state) (in_flow : bmc_flow)
    ((cmd : s_command), (extent : extent)) : bmc_state * bmc_flow =
  match cmd with
  | Sc_assign(var, expr) -> failwith "Sc_assign"
  | Sc_assert(expr) -> failwith "Sc_assert"
  | Sc_if(expr, block1, block2) -> failwith "Sc_if"
  | Sc_while _ -> failwith "Sc_while"
  | Sc_proc_call _ -> failwith "Sc_proc_call"
 
and bmc_expr (in_state : bmc_state) (in_flow : bmc_flow)
  ((expr : s_expr), (extent : extent)) =
  match expr with
  | Se_const (Sc_int i64) -> failwith "i64"
  | Se_const (Sc_bool true) -> failwith "true"
  | Se_const (Sc_bool false) -> failwith "false"
  | Se_binary(op, e1, e2) -> failwith "binary"
  | Se_var(var) -> failwith "var"
  | Se_unary(op, e1) -> failwith "unary"
  | Se_arrayaccess _ -> failwith "Se_array_access"
  | Se_random(lb, ub) -> failwith "random"
       
let bmc_procedure (in_state : bmc_state) (in_flow : bmc_flow) (p : s_proc) =
  bmc_block in_state in_flow p.s_proc_body;;

let bmc_init_state (out : out_channel) (p : s_program) =
  {
    bmc_channel = out;
    bmc_count = 0;
    bmc_error_locations = []
  };;

let bmc_init_flow (state : bmc_state) (p : s_program) =
  let start_name = "start" in
  (* TODO *)
  {
    bmc_reached = start_name;
  };;

let bmc_output_errors (state : bmc_state) =
  match state.bmc_error_locations with
  | [] -> Printf.fprintf state.bmc_channel "(assert false)\n"
  | _::_ ->
     Printf.fprintf state.bmc_channel "(assert (or\n";
    List.iter
      (fun condition -> Printf.fprintf state.bmc_channel "  %s\n" condition)
      state.bmc_error_locations;
    Printf.fprintf state.bmc_channel "))\n";;
      
let bmc_program (chan : out_channel) (p : s_program) =
  match get_main_procedure p with
  | Some proc ->
     let in_state = bmc_init_state chan p in
     let out_state, out_flow = bmc_procedure in_state (bmc_init_flow in_state p) proc in
     bmc_output_errors out_state;
     Printf.fprintf chan "(check-sat)\n"
  | None -> failwith "no main procedure";;
