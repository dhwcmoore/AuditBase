(* Simple working HTTP server *)
open Unix
open Printf

let respond_json content =
  let response = sprintf 
    "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: %d\r\nAccess-Control-Allow-Origin: *\r\n\r\n%s"
    (String.length content) content in
  response

let health_response () =
  {|{"status": "healthy", "version": "2.1.0", "engine": "veribound"}|}

let classify_response domain value =
  let cmd = sprintf "cd /home/duston/VeriBound_process_design && dune exec -- bin/main.exe inspect %s %.2f" domain value in
  let ic = Unix.open_process_in cmd in
  let output = input_line ic in
  let _ = Unix.close_process_in ic in
  
  sprintf {|{"classification": {"domain": "%s", "value": %.2f, "result": "%s"}}|} 
    domain value (String.escaped output)

let parse_simple_json body =
  (* Very simple parsing - just extract domain and value *)
  let domain_start = String.index body '"' + 1 in
  let domain_end = String.index_from body domain_start '"' in
  let domain = String.sub body domain_start (domain_end - domain_start) in
  
  let value_start = String.rindex body ':' + 1 in
  let value_end = String.rindex body '}' in
  let value_str = String.trim (String.sub body value_start (value_end - value_start)) in
  let value = float_of_string value_str in
  
  (domain, value)

let handle_request request =
  let lines = String.split_on_char '\n' request in
  let request_line = List.hd lines in
  
  if String.contains request_line "GET" && String.contains request_line "health" then
    respond_json (health_response ())
  else if String.contains request_line "POST" && String.contains request_line "classify" then
    let body_start = String.index request '\n' in
    let body = String.sub request body_start (String.length request - body_start) in
    let (domain, value) = parse_simple_json body in
    respond_json (classify_response domain value)
  else
    respond_json {|{"error": "Not found"}|}

let start_server port =
  let server_socket = socket PF_INET SOCK_STREAM 0 in
  setsockopt server_socket SO_REUSEADDR true;
  bind server_socket (ADDR_INET (inet_addr_loopback, port));
  listen server_socket 5;
  
  printf "🚀 Simple VeriBound API running on http://localhost:%d\n" port;
  printf "Try: curl http://localhost:%d/health\n" port;
  flush stdout;
  
  while true do
    let (client, _) = accept server_socket in
    let buffer = Bytes.create 1024 in
    let n = recv client buffer 0 1024 [] in
    let request = Bytes.sub_string buffer 0 n in
    
    let response = handle_request request in
    let _ = send client (Bytes.of_string response) 0 (String.length response) [] in
    close client
  done

let () = start_server 8080
