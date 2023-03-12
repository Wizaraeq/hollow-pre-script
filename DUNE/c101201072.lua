--シャルルの叙事詩
function c101201072.initial_effect(c)
	aux.AddCodeList(c,77656797)
	--Special Summon 1 "Infernoble Knight" monster from your hand or Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201072,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,101201072)
	e1:SetTarget(c101201072.target)
	e1:SetOperation(c101201072.activate)
	c:RegisterEffect(e1)
	--Equip 1 "Noble Knight" monster from your hand or Deck to 1 "Infernoble Knight Emperor Charles" you control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201072,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,101201072+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101201072.eqtg)
	e2:SetOperation(c101201072.eqop)
	c:RegisterEffect(e2)
end
function c101201072.cfilter(c,sft,e,tp)
	return c:IsSetCard(0x207a) and c:IsType(TYPE_EQUIP) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c101201072.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c,sft)
end
function c101201072.spfilter(c,e,tp,eq,sft)
	return c:IsSetCard(0x507a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (eq:IsAbleToGrave() or (sft>0 and eq:CheckEquipTarget(c)
		and eq:CheckUniqueOnField(tp) and not eq:IsForbidden()))
end
function c101201072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then sft=sft-1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101201072.cfilter,tp,LOCATION_HAND,0,1,nil,sft,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101201072.activate(e,tp,eg,ep,ev,re,r,rp)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local eq=Duel.SelectMatchingCard(tp,c101201072.cfilter,tp,LOCATION_HAND,0,1,1,nil,sft,e,tp):GetFirst()
	if not eq then return end
	Duel.ConfirmCards(1-tp,eq)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101201072.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,eq,sft):GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local eqBool=sft>0 and eq:CheckEquipTarget(tc) and eq:CheckUniqueOnField(tp) and not eq:IsForbidden()
		local tgBool=eq:IsAbleToGrave()
		if eqBool or tgBool then
			Duel.BreakEffect()
			if eqBool and tgBool then
				op=Duel.SelectOption(tp,aux.Stringid(101201072,2),aux.Stringid(101201072,3))
			elseif eqBool then
				op=Duel.SelectOption(tp,aux.Stringid(101201072,2))
			else
				op=Duel.SelectOption(tp,aux.Stringid(101201072,3))+1
			end
			if op==0 then
				Duel.Equip(tp,eq,tc)
			else
				Duel.SendtoGrave(eq,REASON_EFFECT)
			end
		end
	end
end
function c101201072.eqfilter(c,p)
	return c:IsSetCard(0x107a) and c:IsType(TYPE_MONSTER)
		and c:CheckUniqueOnField(p) and not c:IsForbidden()
end
function c101201072.filter(c)
	return c:IsFaceup() and c:IsCode(77656797)
end
function c101201072.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE)
		and chkc:IsFaceup() and chkc:IsCode(77656797) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101201072.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101201072.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101201072.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101201072.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eq=Duel.SelectMatchingCard(tp,c101201072.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if eq and Duel.Equip(tp,eq,tc) then
		local c=e:GetHandler()
		--Equip Limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetLabelObject(tc)
		e2:SetValue(c101201072.eqlimit)
		eq:RegisterEffect(e2)
		--atk up
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(500)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		eq:RegisterEffect(e3)
	end
end
function c101201072.eqlimit(e,c)
	return c==e:GetLabelObject()
end