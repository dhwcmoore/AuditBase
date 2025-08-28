open Unix

let make_http_response body =
  "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nAccess-Control-Allow-Origin: *\r\n\r\n" ^ body

let test_veribound () =
  let cmd = "cd /home/duston/VeriBound_process_design && dune exec -- bin/main.exe inspect diabetes 6.0" in
  let ic = Unix.open_process_in cmd in
  let result = input_line ic in
  let _ = Unix.close_process_in ic in
  result

let () =
  let server = socket PF_INET SOCK_STREAM 0 in
  setsockopt server SO_REUSEADDR true;
  bind server (ADDR_INET (inet_addr_loopback, 8080));
  listen server 1;
  
  print_endline "🚀 VeriBound API Server running on http://localhost:8080";
  print_endline "Test: curl http://localhost:8080/";
  
  while true do
    let (client, _) = accept server in
    let _ = Bytes.create 100 in
    
    let test_result = test_veribound () in
    let json = "{\"status\": \"working\", \"test\": \"" ^ test_result ^ "\"}" in
    let response = make_http_response json in
    
    let _ = send client (Bytes.of_string response) 0 (String.length response) [] in
    close client;
    print_endline "Request handled"
  done
