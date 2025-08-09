open Unix

let make_response body =
  "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nAccess-Control-Allow-Origin: *\r\n\r\n" ^ body

let call_veribound domain value =
  let cmd = Printf.sprintf "cd /home/duston/VeriBound_process_design && _build/default/bin/main.exe inspect %s %.1f" domain value in
  let ic = Unix.open_process_in cmd in
  let result = input_line ic in
  let _ = Unix.close_process_in ic in
  result

let demo_classifications () =
  let tests = [
    ("aqi", 50.0, "Was Unknown, now Moderate");
    ("aqi", 100.0, "Was Unknown, now USG");  
    ("aqi", 150.0, "Was Unknown, now Unhealthy");
    ("diabetes", 6.0, "Always worked - Prediabetes")
  ] in
  
  let results = List.map (fun (domain, value, note) ->
    let result = call_veribound domain value in
    Printf.sprintf "{\"domain\": \"%s\", \"value\": %.1f, \"result\": \"%s\", \"note\": \"%s\"}" 
      domain value (String.escaped result) note
  ) tests in
  
  "[" ^ (String.concat ", " results) ^ "]"

let () =
  let server = socket PF_INET SOCK_STREAM 0 in
  setsockopt server SO_REUSEADDR true;
  bind server (ADDR_INET (inet_addr_loopback, 3000));
  listen server 5;
  
  print_endline "🚀 Enhanced VeriBound API Server running on http://localhost:3000";
  print_endline "🔬 Demonstrating ALL your boundary gap fixes!";
  
  while true do
    try
      let (client, _) = accept server in
      let buffer = Bytes.create 1024 in
      let _ = recv client buffer 0 1024 [] in
      
      let demo_json = demo_classifications () in
      let json = Printf.sprintf 
        "{\"status\": \"VeriBound API Working\", \"version\": \"2.1.0\", \"boundary_fixes_demo\": %s}" 
        demo_json in
      let response = make_response json in
      
      let _ = send client (Bytes.of_string response) 0 (String.length response) [] in
      close client;
      print_endline "✅ Demonstrated all boundary gap fixes via API!"
    with
      exn -> print_endline ("❌ Error: " ^ (Printexc.to_string exn))
  done
