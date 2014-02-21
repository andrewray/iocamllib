(* table renderers *)

let html f q = Html5.P.print_list ~output:(output_string f) q 

module type Width = sig
    val width : int
end

module type Element = sig
    type t
    val to_string : t -> string
end

module TwoD(E : Element) = struct
    
    type table = E.t list list
    
    let list t = t
    let array t = Array.to_list (Array.map Array.to_list t)

    let write file table = 
        let module Html5 = Html5.M in
        let row = List.map (fun x -> << <td>$str:E.to_string x$</td> >>) in
        let rows = List.map (fun x -> << <tr>$list:row x$</tr> >>) in
        html file [ << <table> $list:rows table$ </table> >> ]
 
    let display table = 
        write Iocaml.mime table;
        Iocaml.send_mime "text/html"

    let printer fmt table = display table; Format.fprintf fmt "<table>"

end

module OneD(E : Element) (W : Width) = struct
    
    module T = TwoD(E)
    include T
    
    let rec f n row table = 
        match table with
        | [] -> if row=[] then [] else [List.rev row]
        | h::t ->
            if n=W.width then List.rev row :: f 0 [] table
            else f (n+1) (h::row) t

    let list t = f 0 [] t

    let array t = list (Array.to_list t)

end

