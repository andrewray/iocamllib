#require "iocamllib";;

(* basic table types *)
module F' = struct
    type t = float
    let to_string = string_of_float
end;;
module W10 = struct
    let width = 10
end;;
module W4 = struct
    let width = 4
end;;
module FT = Iocamllib.Table.OneD(F')(W10);;
module FT2 = Iocamllib.Table.TwoD(F');;
module I' = struct
    type t = int
    let to_string = string_of_int
end;;
module IT = Iocamllib.Table.OneD(I')(W10);;
module IT2 = Iocamllib.Table.TwoD(I');;
module S' = struct
    type t = string
    let to_string x = x
end;;
module ST = Iocamllib.Table.OneD(S')(W4);;
module ST2 = Iocamllib.Table.TwoD(S');;

#install_printer FT.printer;;
#install_printer FT2.printer;;
#install_printer IT.printer;;
#install_printer IT2.printer;;
#install_printer ST.printer;;
#install_printer ST2.printer;;

(* simple image viewer *)
#install_printer Iocamllib.Image.RgbToPng.printer;;

(* TyXML *)
#install_printer Iocamllib.Tyxml.Html.printer;;
#install_printer Iocamllib.Tyxml.Svg.printer;;

(* Cow *)
#install_printer Iocamllib.Icow.Xml.printer;;
#install_printer Iocamllib.Icow.Css.printer;;

(* garbage collection stats *)
#install_printer Iocamllib.Garbage.printer;;

(* polynomials *)
module Poly_int = Iocamllib.Polynomial.Make(Iocamllib.Polynomial.Int);;
module Poly_float = Iocamllib.Polynomial.Make(Iocamllib.Polynomial.Float);;
#install_printer Poly_int.printer;;
#install_printer Poly_float.printer;;

