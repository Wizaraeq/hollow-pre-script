--トリックスター・コルチカ
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--link summon
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	c:EnableReviveLimit()
	--Inflict damage equal to the ATK of a monster destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.damcond)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
end
function s.matfilter(c)
	return c:IsLinkSetCard(0xfb) and not c:IsLinkType(TYPE_LINK)
end
function s.damcfilter(c,tp,ct)
	local bc=c:GetBattleTarget()
	return (c:IsPreviousControler(tp) and c:IsPreviousSetCard(0xfb))
		or (ct==1 and bc and bc:IsControler(tp) and bc:IsSetCard(0xfb))
end
function s.damcond(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.damcfilter,1,nil,tp,#eg)
end
function s.damtgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:GetBaseAttack()>0
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.damtgfilter(chkc,e) end
	if chk==0 then return eg:IsExists(s.damtgfilter,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=eg:FilterSelect(tp,s.damtgfilter,1,1,nil,e)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tg:GetFirst():GetBaseAttack())
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetBaseAttack()>0 then
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end