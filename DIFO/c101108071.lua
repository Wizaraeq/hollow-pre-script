--セリオンズ・スタンダップ
function c101108071.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108071,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101108071)
	e1:SetTarget(c101108071.target)
	e1:SetOperation(c101108071.activate)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108071,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101108071)
	e2:SetCondition(c101108071.eqcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101108071.eqtg)
	e2:SetOperation(c101108071.eqop)
	c:RegisterEffect(e2)
end
function c101108071.spfilter(c,e,tp)
	return c:IsSetCard(0x27a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101108071.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101108071.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101108071.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101108071.eqfilter(c)
	return c:IsSetCard(0x27a) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c101108071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local eg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101108071.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		if #eg>0 and Duel.SelectYesNo(tp,aux.Stringid(101108071,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=eg:Select(tp,1,1,nil):GetFirst()
			if Duel.Equip(tp,ec,tc) then		
				--Equip limit
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(c101108071.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(tc)
				ec:RegisterEffect(e1)
			end
		end
	end
end
function c101108071.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c101108071.eqfilter2(c)
	return c:IsSetCard(0x27a) and c:IsFaceup()
end
function c101108071.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c101108071.eqfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c101108071.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101108071.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ec=Duel.SelectTarget(tp,c101108071.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,ec,1,0,0)
end
function c101108071.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g<2 then return end
	local tc=g:GetFirst()
	local oc=g:GetNext()
	if oc==e:GetLabelObject() then tc,oc=oc,tc end
	if not (tc:IsFaceup() and tc:IsControler(tp)) then return end
	if Duel.Equip(tp,oc,tc) then		
		--Equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c101108071.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		oc:RegisterEffect(e1)
	end
end
function c101108071.eqlimit(e,c)
	return c==e:GetLabelObject()
end