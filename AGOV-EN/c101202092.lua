--Discordance of the Tistina
--Coded by Lee
local s,id,o=GetID()
function s.initial_effect(c)
	--remove 1 card
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a4) 
end
function s.filter1(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end 
function s.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a4) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_GRAVE,nil,tp)
	local b1=#g>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	local b2=#g>0 and Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		e:SetOperation(s.reop1)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE)
		e:SetOperation(s.reop2)
	end
end
function s.reop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,0,LOCATION_GRAVE,1,1,nil,tp)
	if #g>0 then 
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function s.reop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_GRAVE,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function s.thfilter(c)
	return c:IsSetCard(0x1a4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.thfilter(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end