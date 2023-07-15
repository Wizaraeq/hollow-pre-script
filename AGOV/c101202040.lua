--エクシーズ・アーマー・フォートレス
function c101202040.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c101202040.ovfilter,aux.Stringid(101202040,0),2,c101202040.xyzop)
	c:EnableReviveLimit()
	--Cannot be used as material for an Xyz Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetCondition(c101202040.xyzcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Add "Armored Xyz" cards with different names from your Deck to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202040,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101202040.thcost)
	e2:SetTarget(c101202040.thtg)
	e2:SetOperation(c101202040.thop)
	c:RegisterEffect(e2)
	--Double battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(c101202040.damcon)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
end
function c101202040.ovfilter(c)
	return c:IsFaceup() and c:IsRank(3,4)
end
function c101202040.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101202040)==0 end
	Duel.RegisterFlagEffect(tp,101202040,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101202040.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()~=0
end
function c101202040.thfilter(c)
	return c:IsSetCard(0x4073) and c:IsAbleToHand()
end
function c101202040.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101202040.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local rt=math.min(ct,c:GetOverlayCount(),2)
	if chk==0 then return rt>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c101202040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function c101202040.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(c101202040.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1)
end
function c101202040.damcon(e)
	return e:GetHandler():GetEquipTarget():GetBattleTarget()
end