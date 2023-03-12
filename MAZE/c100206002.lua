--Shadow Ghoul of the Labyrinth
function c100206002.initial_effect(c)
	-- Search 1 "Labyrinth Wall" card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100206002)
	e1:SetCost(c100206002.thcost)
	e1:SetTarget(c100206002.thtg)
	e1:SetOperation(c100206002.thop)
	c:RegisterEffect(e1)
	-- Destroy 1 opponent's battling monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100206002,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100206002+100)
	e2:SetCondition(c100206002.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100206002.destg)
	e2:SetOperation(c100206002.desop)
	c:RegisterEffect(e2)
end
function c100206002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100206002.thfilter(c)
	return c:IsSetCard(0x296) and c:IsAbleToHand()
end
function c100206002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100206002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100206002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100206002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100206002.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x296)
end
function c100206002.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleMonster(1-tp) and Duel.IsExistingMatchingCard(c100206002.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100206002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetBattleMonster(1-tp),1,0,0)
end
function c100206002.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetBattleMonster(1-tp)
	if tc and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
