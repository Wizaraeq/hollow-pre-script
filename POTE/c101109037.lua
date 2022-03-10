--お代狸様の代算様
function c101109037.initial_effect(c)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	--extra material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(101109037)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetCountLimit(1,101109037)
	e3:SetTarget(c101109037.mttg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--extra material
	if not aux.rit_mat_hack_check then
	aux.rit_mat_hack_check=true
		function aux.rit_mat_hack_exmat_filter(c)
			return c:IsHasEffect(101109037,c:GetControler())
		end
		local _GetRitualMaterial=Duel.GetRitualMaterial
		local _ReleaseRitualMaterial=Duel.ReleaseRitualMaterial
		function Duel.GetRitualMaterial(tp)
			local g=_GetRitualMaterial(tp)
			local xg=Duel.GetMatchingGroup(aux.rit_mat_hack_exmat_filter,tp,LOCATION_EXTRA,0,nil)
			for xc in aux.Next(xg) do
				g:Merge(xg)
			end
			return g
		end
		function Duel.ReleaseRitualMaterial(mat)
			local xmat=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			mat:Sub(xmat)
			Duel.SendtoGrave(xmat,REASON_RITUAL+REASON_EFFECT+REASON_MATERIAL)
			_ReleaseRitualMaterial(mat)
		end
	end
end
function c101109037.mttg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end