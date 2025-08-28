open Unix
open Printf

let make_response content =
  sprintf "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: %d\r\nAccess-Control-Allow-Origin: *\r\n\r\n%s"
    (String.length content) content

let run_classification domain value =
  let cmd = sprintf "dune exec -- bin/main.exe inspect %s %.1f" domain value in
  let result = Unix.open_process_in cmd in
  let output = input_line result in
  let _ = Unix.close_process_in result in
  output

let () =
  let port = 8080 in
  let server = socket PF_INET SOCK_STREAM 0 in
  setsockopt server SO_REUSEADDR true;
  bind server (ADDR_INET (inet_addr_loopback, port));
  listen server 5;
  
  printf "🚀 VeriBound API Server running on port %d\n" port;
  printf "Test with: curl http://localhost:%d/\n" port;
  flush stdout;
  
  while true do
    let (client, _) = accept server in
    let buffer = Bytes.create 512 in
    let _ = recv client buffer 0 512 [] in
    
    (* Simple fixed response for now *)
    let json_response = {|{"status": "VeriBound API Working", "test_classification": "Ready"}|} in
    let response = make_response json_response in
    
    let _ = send client (Bytes.of_string response) 0 (String.length response) [] in
    close client;
    
    printf "Request handled\n";
    flush stdout
  done
