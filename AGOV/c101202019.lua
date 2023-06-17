--ブエリヤベース・ド・ヌーベルズ
function c101202019.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Special Summon itself form the pendulum Zone and change the position of a monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101202019)
	e1:SetCondition(c101202019.spcon)
	e1:SetTarget(c101202019.sptg)
	e1:SetOperation(c101202019.spop)
	c:RegisterEffect(e1)
	--Place itself in the Pendulum Zone if it is tributed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202019,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCondition(c101202019.pencon)
	e2:SetTarget(c101202019.pentg)
	e2:SetOperation(c101202019.penop)
	c:RegisterEffect(e2)
	--Search 1 Level 1 Ritual monster/"Recipe" card OR Special Summon 1 "Nouvelles" Ritual Monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202019,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101202019+100)
	e3:SetTarget(c101202019.target)
	e3:SetOperation(c101202019.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c101202019.spcfilter(c)
	return c:IsSetCard(0x197) or c:IsType(TYPE_RITUAL)
end
function c101202019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202019.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101202019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101202019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c101202019.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c101202019.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c101202019.penop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c101202019.thfilter(c)
	return (c:IsSetCard(0x197) or (c:IsType(TYPE_RITUAL) and c:IsLevel(1))) and c:IsAbleToHand()
end
function c101202019.rmvfilter(c)
	return c:IsSetCard(0x197) and c:IsAbleToRemove()
end
function c101202019.nvlfilter(c,e,tp,lv)
	return c:IsSetCard(0x196) and c:IsType(TYPE_RITUAL)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsLevelBelow(lv)
end
function c101202019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(c101202019.rmvfilter,tp,LOCATION_GRAVE,0,nil)
	local b1=Duel.IsExistingMatchingCard(c101202019.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #rg>0
		and Duel.IsExistingMatchingCard(c101202019.nvlfilter,tp,LOCATION_HAND,0,1,nil,e,tp,#rg)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(101202019,3)},
		{b2,aux.Stringid(101202019,4)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c101202019.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		--Search 1 Level 1 Ritual monster or Recipe card
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101202019.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		local rg=Duel.GetMatchingGroup(c101202019.rmvfilter,tp,LOCATION_GRAVE,0,nil)
		if #rg==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rmg=rg:SelectSubGroup(tp,c101202019.rescon,false,1,#rg,e,tp)
		--Currently stops automatically at the minimum number met to summon a Ritual, which is wrong
		if #rmg>0 and Duel.Remove(rmg,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c101202019.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,#rmg)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,true,POS_FACEUP)
			end
		end
	end
end
function c101202019.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(c101202019.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp,#sg)
end
function c101202019.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0x196) and c:IsType(TYPE_RITUAL)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsLevel(lv)
end
