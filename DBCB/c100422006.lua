--ライゼオル・デュオドライブ
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--Attach 1 "Raizeol" monster from your GY to this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.attachtg)
	e1:SetOperation(s.attachop)
	c:RegisterEffect(e1)
	--Monsters you control gain 100 ATK per Xyz material this card has
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(s.atkvalue1)
	c:RegisterEffect(e2)
	--Monsters you control gain 100 ATK per Xyz material this card has
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_UPDATE_ATTACK)
	e2b:SetTargetRange(0,LOCATION_MZONE)
	e2b:SetValue(s.atkvalue2)
	c:RegisterEffect(e2b)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.attachfilter(c)
	return c:IsSetCard(0x2bd) and c:IsType(TYPE_MONSTER)
end
function s.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.attachfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function s.attachop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.attachfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Overlay(c,g)
	end
end
function s.atkvalue1(e,c)
	return 100*e:GetHandler():GetOverlayCount()
end
function s.atkvalue2(e,c)
	return -100*e:GetHandler():GetOverlayCount()
end
function s.atkvalue(e,c)
	local ct=e:GetHandler():GetOverlayCount()
	if c:IsControler(e:GetHandlerPlayer()) then
		return 100*ct
	else
		return -100*ct
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x2bd) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT)
		and  #g>=2 and g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_EFFECT)==2 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if #g<2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if #thg>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
end