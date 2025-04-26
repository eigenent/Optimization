$onText
Optimizing truss
$offText

Scalars
* All these are in SI, so meters, Newton, kg
   Len  "length" / 3.36 /
   F1   "force 1" / -980665 /
   F2   "force 2" / -980665 /
* stainless steel s355
   E_ss   "Young's modulus"  / 206010000000 /
   rho_ss  "Material Density" / 7930 /
* Titanium Grade 5 (6AL4V)
   E_ti   "Young's modulus"  / 71003446602 /
   rho_ti  "Material Density" / 4420 /
* Magnesium alloy (8.5% Al)
   E_ma   "Young's modulus"  / 45002184466 /
   rho_ma  "Material Density" / 1738 /
* Aluminum Alloy 1100-H14 (99% Al)
   E_aa    "Young's modulus"  / 26001262136 /
   rho_aa  "Material Density" / 2710 /;



Variables
u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12, mass, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, rho1, rho2, rho3, rho4, rho5, rho6, rho7, rho8, rho9, rho10;

Equations
r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, object, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10;

* u = F/K



object.. mass =e= rho1*Len*A1 +  rho2*Len*A2 + rho3*Len*A3*rpower(2, 0.5) + rho4*Len*A4*rpower(2, 0.5) + rho5*Len*A5 + rho6*Len*A6 + rho7*Len*A7 + rho8*Len*A8*rpower(2, 0.5) + rho9*Len*A9*rpower(2, 0.5) + rho10*Len*A10;

p1.. 0 =e= [(E1 - E_ss)**2 + (rho1 - rho_ss)**2]*[(E1 - E_ti)**2 + (rho1 - rho_ti)**2]*[(E1 - E_ma)**2 + (rho1 - rho_ma)**2]*[(E1 - E_aa)**2 + (rho1 - rho_aa)**2];
p2.. 0 =e= [(E2 - E_ss)**2 + (rho2 - rho_ss)**2]*[(E2 - E_ti)**2 + (rho2 - rho_ti)**2]*[(E2 - E_ma)**2 + (rho2 - rho_ma)**2]*[(E2 - E_aa)**2 + (rho2 - rho_aa)**2];
p3.. 0 =e= [(E3 - E_ss)**2 + (rho3 - rho_ss)**2]*[(E3 - E_ti)**2 + (rho3 - rho_ti)**2]*[(E3 - E_ma)**2 + (rho3 - rho_ma)**2]*[(E3 - E_aa)**2 + (rho3 - rho_aa)**2];
p4.. 0 =e= [(E4 - E_ss)**2 + (rho4 - rho_ss)**2]*[(E4 - E_ti)**2 + (rho4 - rho_ti)**2]*[(E4 - E_ma)**2 + (rho4 - rho_ma)**2]*[(E4 - E_aa)**2 + (rho4 - rho_aa)**2];
p5.. 0 =e= [(E5 - E_ss)**2 + (rho5 - rho_ss)**2]*[(E5 - E_ti)**2 + (rho5 - rho_ti)**2]*[(E5 - E_ma)**2 + (rho5 - rho_ma)**2]*[(E5 - E_aa)**2 + (rho5 - rho_aa)**2];
p6.. 0 =e= [(E6 - E_ss)**2 + (rho6 - rho_ss)**2]*[(E6 - E_ti)**2 + (rho6 - rho_ti)**2]*[(E6 - E_ma)**2 + (rho6 - rho_ma)**2]*[(E6 - E_aa)**2 + (rho6 - rho_aa)**2];
p7.. 0 =e= [(E7 - E_ss)**2 + (rho7 - rho_ss)**2]*[(E7 - E_ti)**2 + (rho7 - rho_ti)**2]*[(E7 - E_ma)**2 + (rho7 - rho_ma)**2]*[(E7 - E_aa)**2 + (rho7 - rho_aa)**2];
p8.. 0 =e= [(E8 - E_ss)**2 + (rho8 - rho_ss)**2]*[(E8 - E_ti)**2 + (rho8 - rho_ti)**2]*[(E8 - E_ma)**2 + (rho8 - rho_ma)**2]*[(E8 - E_aa)**2 + (rho8 - rho_aa)**2];
p9.. 0 =e= [(E9 - E_ss)**2 + (rho9 - rho_ss)**2]*[(E9 - E_ti)**2 + (rho9 - rho_ti)**2]*[(E9 - E_ma)**2 + (rho9 - rho_ma)**2]*[(E9 - E_aa)**2 + (rho9 - rho_aa)**2];
p10.. 0 =e= [(E10 - E_ss)**2 + (rho10 - rho_ss)**2]*[(E10 - E_ti)**2 + (rho10 - rho_ti)**2]*[(E10 - E_ma)**2 + (rho10 - rho_ma)**2]*[(E10 - E_aa)**2 + (rho10 - rho_aa)**2];

 
*initial values for displacements
u1.l = 1;
u2.l = 1;
u3.l = 1;
u4.l = 1;
u5.l = 1;
u6.l = 1;
u7.l = 1;
u8.l = 1;
u9.l = 1;
u10.l = 1;
u11.l = 1;
u12.l = 1;

* initial values for cross section
A1.l = 3.72e-4;
A2.l = 3.72e-4;
A3.l = 3.72e-4;
A4.l = 3.72e-4;
A5.l = 3.72e-4;
A6.l = 3.72e-4;
A7.l = 3.72e-4;
A8.l = 3.72e-4;
A9.l = 3.72e-4;
A10.l = 3.72e-4;

* further logical constraints
A1.lo = 0;
A2.lo = 0;
A3.lo = 0;
A4.lo = 0;
A5.lo = 0;
A6.lo = 0;
A7.lo = 0;
A8.lo = 0;
A9.lo = 0;
A10.lo = 0;

* deformations not exceeding the unoptimized problem

* original constrains 
u1.lo = -0.1013; u1.up = 0.1013;
u2.lo = -0.4533; u2.up = 0.4533;
u3.lo = -0.1137; u3.up = 0.1137;
u4.lo = -0.4705; u4.up = 0.4705;
u5.lo = -0.0840; u5.up = 0.0840;
u6.lo = -0.2000; u6.up = 0.2000;
u7.lo = -0.0880; u7.up = 0.0880;
u8.lo = -0.2152; u8.up = 0.2152;
mass.lo = 0;

* original constrains (relaxed constraits)
*u1.lo = -0.1013; u1.up = 0.1013;
*u2.lo = -0.4533; u2.up = 0.4533;
*u3.lo = -0.1137*2; u3.up = 0.1137*2;
*u4.lo = -0.4705*2; u4.up = 0.4705*2;
*u5.lo = -0.0840; u5.up = 0.0840;
*u6.lo = -0.2000; u6.up = 0.2000;
*u7.lo = -0.0880; u7.up = 0.0880;
*u8.lo = -0.2152*2; u8.up = 0.2152*2;
*mass.lo = 0;

* zeta question (uncomment these and comment the other constraints to get the relevant results)
*u1.lo = -0.1013/2; u1.up = 0.1013/2;
*u2.lo = -0.4533/2; u2.up = 0.4533/2;
*u3.lo = -0.1137/2; u3.up = 0.1137/2;
*u4.lo = -0.4705/2; u4.up = 0.4705/2;
*u5.lo = -0.0840/2; u5.up = 0.0840/2;
*u6.lo = -0.2000/2; u6.up = 0.2000/2;
*u7.lo = -0.0880/2; u7.up = 0.0880/2;
*u8.lo = -0.2152/2; u8.up = 0.2152/2;
*mass.lo = 0; 

model truss_opti /all/;
option nlp = ipopt;
solve truss_opti minimizing mass using nlp;
