--暗黒神殿ザララーム
function c100417033.initial_effect(c)
	aux.AddCodeList(c,100417125)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--No Activations during BP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c100417033.actcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Burn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100417033,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100417033.bcon)
	e3:SetTarget(c100417033.btg)
	e3:SetOperation(c100417033.bop)
	c:RegisterEffect(e3)
	--Search a Field Spell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100417033,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c100417033.thcon)
	e4:SetTarget(c100417033.thtg)
	e4:SetOperation(c100417033.thop)
	c:RegisterEffect(e4)
end
function c100417033.eqfilter(c)
	return c:GetEquipGroup():IsExists(Card.IsCode,1,nil,100417030)
end
function c100417033.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c100417033.eqfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c100417033.bcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE) and rc:IsControler(tp) and rc:IsFaceup() and rc:IsCode(100417125)
end
function c100417033.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,100417033,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,eg:GetFirst():GetBattleTarget():GetTextAttack(),1-tp,0)
end
function c100417033.bop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,eg:GetFirst():GetBattleTarget():GetTextAttack(),REASON_EFFECT)
end
function c100417033.thfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand() and not c:IsCode(100417033) and aux.IsCodeListed(c,100417125)
end
function c100417033.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,100417033)>0
end
function c100417033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417033.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100417033.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100417033.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end