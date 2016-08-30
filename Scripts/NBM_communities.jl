include("read_graph.jl")

run(`cowsay Frankie says RELAX`)

using RCall

function la_matriz(g)
    A = full(adjacency_matrix(g))
    ceros = zeros(A)
    D = zeros(A)
    menos = -1 * eye(A)
    for n in 1:nv(g)
        D[n,n] = degree(g,n)-1
    end
    hcat(vcat(ceros,menos),vcat(D,A))
end

M = la_matriz(g)
valores = eigvals(M)
treshold = real(sqrt(valores[1]))

mmm = eigvals(M)

cuantos = Array(Float64,0)
index = Array(Int64,0)
for i in 1:length(mmm)
    if imag(mmm[i]) == 0 && real(mmm[i]) > treshold
        push!(cuantos,real(mmm[i]))
        push!(index,i)
    end
end

print("There are $(length(cuantos)) communities in this Network \n")

matriz_embedded = real(eigvecs(M)[:,index])
arriba = matriz_embedded[1:nv(g),:]
abajo = matriz_embedded[nv(g)+1:2*nv(g),:]
hola = arriba + abajo

R_kmeans = R"kmeans";

function membresia(n,v)
    membresia = Array(Int64,0)
    if n == 2
        for i in 1:length(v[:,1])
            if sign(v[i,2]) == sign(1)
                push!(membresia,1)
            else
                push!(membresia,2)
            end
        end
    else
        matriz_sirve = v
        cluster_p = R_kmeans(matriz_sirve[:,2:n-1],n,nstart=500)
        for i in 1:length(cluster_p[1])
            push!(membresia,cluster_p[1][i])
        end
    end
    membresia
end

grupos = membresia(length(index),hola)

if typeof(red[1,1]) != Int
  comunidades = hcat(Nodes,grupos)
else
  comunidades = hcat(vertices(g),grupos)
end

print("Your results will be saved as: NBM_communities_$(a[k]) \n")
writedlm("../Resultados/NBM_communities_$(a[k])",comunidades)
