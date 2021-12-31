--Zektrike Kou-Ou
function c100282037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100282037+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100282037.cost)
	e1:SetTarget(c100282037.target)
	e1:SetOperation(c100282037.activate)
	c:RegisterEffect(e1)
end
function c100282037.tgcostfilter(c,e,tp,ft)
	return c:IsSetCard(0x56) and c:IsAbleToGraveAsCost() and ((c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or (Duel.GetMZoneCount(tp,c)>0 and c:IsLocation(LOCATION_MZONE)))) or c:IsLocation(LOCATION_HAND))
		and (Duel.IsExistingMatchingCard(c100282037.monfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft,c)
		or (Duel.IsExistingMatchingCard(c100282037.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) and ft>0))
end
function c100282037.monfilter(c,e,tp,ft,sc)
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER) and 
	((Duel.GetMZoneCount(tp,sc)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or ((ft>0 or (sc and sc:IsLocation(LOCATION_SZONE) and sc:GetSequence()<5)) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c100282037.cfilter,tp,LOCATION_MZONE,0,1,sc)))
end
function c100282037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsLocation(LOCATION_HAND) then ft=ft-1 end
	if chk==0 then return Duel.IsExistingMatchingCard(c100282037.tgcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100282037.tgcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,e,tp,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100282037.opfilter(c,e,tp,spchk,eqchk)
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER)
		and (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or eqchk and c:CheckUniqueOnField(tp) and not c:IsForbidden())
end
function c100282037.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x56)
end
function c100282037.eqfilter(c,tp)
	return c:IsSetCard(0x56) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c100282037.tgfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c100282037.tgfilter(c,eqc)
	return c:IsFaceup() and c:IsSetCard(0x56) and eqc:CheckEquipTarget(c)
end
function c100282037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local eqchk=Duel.IsExistingMatchingCard(c100282037.cfilter,tp,LOCATION_MZONE,0,1,nil) and sft>0
	local b1=Duel.IsExistingMatchingCard(c100282037.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk,eqchk)
	local b2=Duel.IsExistingMatchingCard(c100282037.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) and sft>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100282037,0),aux.Stringid(100282037,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100282037,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100282037,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	end
end
function c100282037.activate(e,tp,eg,ep,ev,re,r,rp)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetLabel()==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local eqchk=Duel.IsExistingMatchingCard(c100282037.cfilter,tp,LOCATION_MZONE,0,1,nil) and sft>0
	local g=Duel.SelectMatchingCard(tp,c100282037.opfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,spchk,eqchk)
	local tc=g:GetFirst()
	if tc then
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and spchk
			and (not eqchk or Duel.SelectOption(tp,1152,aux.Stringid(100282037,2))==0) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,c100282037.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			local sc=sg:GetFirst() 
			if sc then
				if not Duel.Equip(tp,tc,sc) then return end
				--equip limit
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetLabelObject(sc)
				e1:SetValue(c100282037.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				end
			end
		end
	else
	if sft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c100282037.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,c100282037.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,ec):GetFirst() 
			Duel.Equip(tp,ec,tc)
		end
		end
	end
end
function c100282037.eqlimit(e,c)
	return c==e:GetLabelObject()
end