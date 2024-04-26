--面子蝙蝠
local s,id,o=GetID()
function s.initial_effect(c)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(3)
	e1:SetTarget(s.postg1)
	e1:SetOperation(s.posop1)
	c:RegisterEffect(e1)
	local g1=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS,g1)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SUMMON_SUCCESS,g1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CUSTOM+id+o)
	e2:SetCountLimit(1)
	e2:SetTarget(s.postg2)
	e2:SetOperation(s.posop2)
	c:RegisterEffect(e2)
	local g2=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,id+o,EVENT_CHANGE_POS,g2)
end
function s.posfilter1(c,e,tp)
	return  c:IsSummonPlayer(1-tp) and (c:IsCanChangePosition() or c:IsCanTurnSet()) and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_MZONE)
end
function s.postg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.posfilter1,1,nil,e,tp) end
	local tc=eg:FilterSelect(tp,s.posfilter1,1,1,nil,e,tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
end
function s.posop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local coin=Duel.TossCoin(tp,1)
	if coin==1 and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	elseif coin==0 and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function s.posfilter2(c,e)
	return c:IsCanTurnSet() or not c:IsPosition(POS_FACEUP_ATTACK) and ((c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()) or (c:IsPreviousPosition(POS_FACEDOWN) and c:IsFaceup())) and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_MZONE)
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(s.posfilter2,1,nil,e) and not eg:IsContains(e:GetHandler()) end
	local tc=eg:FilterSelect(tp,s.posfilter2,1,1,nil,e)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	elseif tc:IsPosition(POS_FACEDOWN_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	elseif tc:IsCanTurnSet() then
		local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		Duel.ChangePosition(tc,pos)
	else
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	end
end