module type Elt = sig
    type elt
    val to_string : elt -> string
    val zero : elt
    val one : elt
    val equal : elt -> elt -> bool
end

module type Poly = sig
    type elt
    type t 

    val list : elt list -> t
    val array : elt array -> t

    val write : out_channel -> t -> unit
    val display : t -> unit
    val printer : Format.formatter -> t -> unit
end

module Int = struct
    type elt = int
    let to_string = string_of_int
    let zero = 0
    let one = 1
    let equal = (=)
end

module Float = struct
    type elt = float
    let to_string x = string_of_float x
    let zero = 0.
    let one = 1.
    let equal a b = if abs_float(a -. b) <= epsilon_float then true else false
end

module Make(E : Elt) = struct
    type elt = E.elt
    type t = elt list
    
    let write f l = 
        let l = List.mapi (fun p x ->
            match p with
            | 0 -> begin
                if E.equal x E.zero then ""
                else E.to_string x
            end
            | 1 -> begin
                if E.equal x E.zero then ""
                else if E.equal x E.one then "x"
                else E.to_string x ^ "x"
            end
            | _ -> begin
                if E.equal x E.zero then ""
                else if E.equal x E.one then "x^{" ^ string_of_int p ^ "}"
                else E.to_string x ^ "x^{" ^ string_of_int p ^ "}"
            end) l
        in
        let l = List.filter ((<>)"") l in
        let str = 
            match l with
            | [] -> E.to_string E.zero
            | _ -> String.concat "+" (List.rev l)
        in
        output_string Iocaml.mime "$$";
        output_string Iocaml.mime str;
        output_string Iocaml.mime "$$"

    let display l = write Iocaml.mime l; Iocaml.send_mime "text/html"
    let printer fmt l = display l; Format.fprintf fmt "<poly>"

    let list l = l
    let array a = Array.to_list a

end


