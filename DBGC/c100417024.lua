--エクソシスター・バディス
function c100417024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417024+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100417024.cost)
	e1:SetTarget(c100417024.target)
	e1:SetOperation(c100417024.activate)
	c:RegisterEffect(e1)
end
function c100417024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c100417024.filter(c,e,tp)
	return c:IsSetCard(0x271) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100417024.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c100417024.filter2(c,e,tp,mc)
	return c:IsSetCard(0x271) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(mc,c:GetCode())
end
function c100417024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c100417024.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c100417024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100417024.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(c100417024.filter2,tp,LOCATION_DECK,0,nil,e,tp,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc:RegisterFlagEffect(100417024,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				tc=g:GetNext()
			end
			Duel.SpecialSummonComplete()
			g:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(g)
			e1:SetCondition(c100417024.tdcon)
			e1:SetOperation(c100417024.tdop)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c100417024.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c100417024.splimit(e,c)
	return not c:IsSetCard(0x271) and c:IsLocation(LOCATION_EXTRA)
end
function c100417024.tdfilter(c,fid)
	return c:GetFlagEffectLabel(100417024)==fid
end
function c100417024.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c100417024.tdfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c100417024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c100417024.tdfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end