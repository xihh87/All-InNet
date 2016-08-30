"""
      Aún está incompleto, falta revisar el número de
          comunidades óptimas que se tienen
                      """


include("read_graph.jl")

run(`cowsay Frankie says RELAX`)

using RCall

A = full(laplacian_matrix(g))
los_que_sirven = eigvecs(A)

R_kmeans = R"kmeans";

function membresia(g,n)
    membresia = Array(Int64,0)
    if n == 2
        for i in 1:length(los_que_sirven[:,2])
            if sign(los_que_sirven[i,2]) == sign(1)
                push!(membresia,1)
            else
                push!(membresia,2)
            end
        end
    else
        matriz_sirve = los_que_sirven
        cluster_p = R_kmeans(matriz_sirve[:,2:n],n,nstart=500)
        for i in 1:length(cluster_p[1])
            push!(membresia,cluster_p[1][i])
        end
    end
    membresia
end

print("\n")
print("How many communties would you like to have?")
print("\n")
k = readline(STDIN)
k = parse(Int,k)

grupos = membresia(k,hola)

if typeof(red[1,1]) != Int
  comunidades = hcat(Nodes,grupos)
else
  comunidades = hcat(vertices(g),grupos)
end

print("Type the name of the file where the partitions will be saved (This will be a .txt file). \n")
name = readline(STDIN)
writedlm("../Resultados/$name.txt",comunidades)
