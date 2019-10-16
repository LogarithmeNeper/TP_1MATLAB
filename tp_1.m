A = [
        5 2;
        1 3;
    ];

B = [1; 2];
X0 = [0; 0];
iterations = 5;

%La solution � trouver
T = inv(A) * B;

J = jacobi(A, B, X0, iterations);
G = gauss_seidel(A, B, X0, iterations);
R = relaxation(A, B, X0, iterations);