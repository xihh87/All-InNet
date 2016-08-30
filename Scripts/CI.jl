include("read_graph.jl")

function CI(g,n)
  CI = zeros(nv(g))
  for v in 1:nv(g)
    vec = neighbors(g, vertices(g)[v])
    vec2 = vec
    vec = vcat(vertices(g)[v],vec)
    todos = vec
    distn = Array(Int64,0)
    for l in 1:(n-1)
      todos = union(vec,vec2)
      for m in vec2
        vec2 = union(vec2,neighbors(g,m))
      end
      distn = setdiff(vec2,todos)
    end
    δ = zeros(distn)
    for m in 1:length(distn)
      δ[m] = degree(g,distn[m])-1
    end
    σ = sum(δ)
    CI[v] = σ * (degree(g,vertices(g)[v])-1)
  end
  CI = round(Int64,CI)
end

print("Type the radius \n")
n = readline(STDIN)
n = parse(Int,n)
print("\n")

run(`cowsay Frankie says RELAX`)

collective = CI(g,n)

if typeof(red[1,1]) != Int
  collective = hcat(Nodes,collective)
else
  collective = hcat(vertices(g),collective)
end
collective = sortrows(collective, by = x->(x[2]), rev=true)



print("Your results will be saved as: CI_rad_$(n)_$(a[k]) \n")
writedlm("../Resultados/CI_rad_$(n)_$(a[k])",collective)
