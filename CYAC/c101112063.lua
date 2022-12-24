--リブロマンサー・オリジン
function c101112063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112063,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101112063+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101112063.setop)
	c:RegisterEffect(e1)
	--"Libromancer" Ritual Monsters gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101112063.atktg)
	e2:SetValue(c101112063.atkval)
	c:RegisterEffect(e2)
	--Destroy 1 Spell/Trap your opponent controls
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112063,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101112063+100)
	e3:SetCondition(c101112063.descon)
	e3:SetTarget(c101112063.destg)
	e3:SetOperation(c101112063.desop)
	c:RegisterEffect(e3)
end
function c101112063.setfilter(c)
	return c:IsSetCard(0x17c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(101112063) and c:IsSSetable()
end
function c101112063.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101112063.setfilter,tp,LOCATION_DECK,0,nil)
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(101112063,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SSet(tp,sg)
	end
end
function c101112063.atktg(e,c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x17c)
end
function c101112063.atkval(e,c)
	return c:GetLevel()*100
end
function c101112063.desconfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c101112063.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112063.desconfilter,1,nil,tp)
end
function c101112063.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101112063.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c101112063.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101112063.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101112063.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101112063.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end