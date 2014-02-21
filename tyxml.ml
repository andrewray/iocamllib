(* tyxml printers *)

module Html = struct
    let write f l = Html5.P.print_list ~output:(output_string f) l
    let display l = write Iocaml.mime l; Iocaml.send_mime "text/html"
    let printer fmt l = display l; Format.fprintf fmt "<html>"
end

module Svg = struct
    let write f l = Svg.P.print_list ~output:(output_string f) l
    let display l = write Iocaml.mime l; Iocaml.send_mime "image/svg+xml"
    let printer fmt l = display l; Format.fprintf fmt "<svg>"
end

