module type Elt = sig
    type elt
    val to_string : elt -> string
    val zero : elt
    val one : elt
    val equal : elt -> elt -> bool
end

module Int : Elt with type elt = int
module Float : Elt with type elt = float

module type Poly = sig
    type elt
    type t 

    val list : elt list -> t
    val array : elt array -> t

    val write : out_channel -> t -> unit
    val display : t -> unit
    val printer : Format.formatter -> t -> unit
end

module Make(E : Elt) : Poly with type elt = E.elt
