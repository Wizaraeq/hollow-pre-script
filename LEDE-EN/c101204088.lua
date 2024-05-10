--Aiza the Dragoness of Deranged Devotion
local s,id,o=GetID()
function s.initial_effect(c)
	--Place 1 Deranged Counter on opponent monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--Destroy monster with Deranged Counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x106b,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x106b,1)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x106b,1):GetFirst()
	if tc and tc:AddCounter(0x106b,1) and tc:GetFlagEffect(id)==0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		e1:SetCondition(s.limcon)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(s.fuslimit)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e6)
	end
end
function s.limcon(e)
	return e:GetHandler():GetCounter(0x106b)>0
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:GetCounter(0x106b)>0 and bc:IsControler(1-tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,PLAYER_ALL,bc:GetBaseAttack())
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) and Duel.Destroy(bc,REASON_EFFECT)>0 then
		local dam=bc:GetBaseAttack()
		if dam>0 then
			Duel.Damage(tp,dam,REASON_EFFECT,true)
			Duel.Damage(1-tp,dam,REASON_EFFECT,true)
			Duel.RDComplete()
		end
	end
	if c:IsRelateToBattle() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetOperation(s.sdesop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e2)
	end
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
