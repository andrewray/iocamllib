module type Width = sig
    val width : int
end

module type Element = sig
    type t
    val to_string : t -> string
end

module TwoD(E : Element) : sig
    type table
    val list : E.t list list -> table
    val array : E.t array array -> table
    val write : out_channel -> table -> unit
    val display : table -> unit
    val printer : Format.formatter -> table -> unit
end

module OneD(E : Element) (W : Width) : sig
    type table
    val list : E.t list -> table
    val array : E.t array -> table
    val write : out_channel -> table -> unit
    val display : table -> unit
    val printer : Format.formatter -> table -> unit
end

