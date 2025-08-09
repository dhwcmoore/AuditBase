open Unix

let make_response () =
  "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nAccess-Control-Allow-Origin: *\r\n\r\n{\"status\": \"VeriBound API is alive\", \"version\": \"2.1.0\"}"

let () =
  let server = socket PF_INET SOCK_STREAM 0 in
  setsockopt server SO_REUSEADDR true;
  bind server (ADDR_INET (inet_addr_loopback, 8080));
  listen server 5;
  
  print_endline "🚀 Basic server running on http://localhost:8080";
  
  while true do
    try
      let (client, _) = accept server in
      let buffer = Bytes.create 1024 in
      let _ = recv client buffer 0 1024 [] in
      
      let response = make_response () in
      let _ = send client (Bytes.of_string response) 0 (String.length response) [] in
      close client;
      print_endline "✅ Request handled successfully"
    with
      exn -> print_endline ("❌ Error: " ^ (Printexc.to_string exn))
  done
