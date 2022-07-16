--精霊冥騎－急還馬
function c101110036.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Send itself to the GY if it's not the Battle Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetCondition(c101110036.tgcon)
	c:RegisterEffect(e1)
	--Special Summon itself at the start of the Battle Phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110036,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101110036)
	e2:SetCost(c101110036.spcost)
	e2:SetTarget(c101110036.sptg)
	e2:SetOperation(c101110036.spop)
	c:RegisterEffect(e2)
end
function c101110036.tgcon(e)
	local ph=Duel.GetCurrentPhase()
	return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c101110036.costfilter(c,tp)
	return c:IsRace(RACE_PLANT) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c101110036.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101110036.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101110036.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101110036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101110036.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101110036.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sg=Group.CreateGroup()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		sg:AddCard(c)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c101110036.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(101110036,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101110036.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
			if #g>0 then
				Duel.BreakEffect()
				if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
					sg:Merge(g)
				end
			end
		end
	end
	local fid=c:GetFieldID()
	for tc in aux.Next(sg) do
		tc:RegisterFlagEffect(101110036,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	sg:KeepAlive()
	--Send the summoned monsters to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(sg)
	e1:SetCondition(c101110036.tgcond)
	e1:SetOperation(c101110036.tgop)
	Duel.RegisterEffect(e1,tp)
end
function c101110036.tgfilter(c,fid)
	return c:GetFlagEffectLabel(101110036)==fid
end
function c101110036.tgcond(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c101110036.tgfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c101110036.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c101110036.tgfilter,nil,e:GetLabel())
	Duel.SendtoGrave(tg,REASON_EFFECT)
end
