--ペンギン勇士
function c101106024.initial_effect(c)
	--Synchro limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c101106024.synlimit)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101106024)
	e2:SetCondition(c101106024.spcon1)
	e2:SetTarget(c101106024.sptg)
	e2:SetOperation(c101106024.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_MSET)
	e3:SetCondition(c101106024.spcon2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101106024.spcon2)
	c:RegisterEffect(e4)
	--Change Position
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,101106024+100)
	e5:SetTarget(c101106024.postg)
	e5:SetOperation(c101106024.posop)
	c:RegisterEffect(e5)
end
function c101106024.synlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c101106024.filter1(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown() and c:IsControler(tp)
end
function c101106024.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101106024.filter1,1,nil,tp)
end
function c101106024.filter2(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function c101106024.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101106024.filter2,1,nil,tp)
end
function c101106024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101106024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(101106024,2)) then
		--Reduce level
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101106024,3))
		local lv=Duel.AnnounceLevel(tp,1,2)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-lv)
		c:RegisterEffect(e1)
	end
end
function c101106024.posfilter(c)
	return c:IsFacedown() and c:IsDefensePos() and c:IsCanChangePosition()
end
function c101106024.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101106024.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101106024.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWNDEFENSE)
	Duel.SelectTarget(tp,c101106024.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101106024.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
		if tc:IsFaceup() and not tc:IsSetCard(0x5a) then
			--Negate its effects
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end